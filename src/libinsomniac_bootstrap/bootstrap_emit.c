#include "bootstrap_internal.h"
#include "scheme.h"
#include "lexer.h"

#include <errno.h>
#include <assert.h>

/* Emit a generic operations */
void emit_op(buffer_type *buf, char *str) {
    int length = strlen(str);

    emit_indent(buf);
    buffer_write(buf, (uint8_t *)str, length);
    emit_newline(buf);
}

/* Emit a label */
void emit_label(buffer_type *buf, buffer_type *label) {

  buffer_append(buf, label, -1);
  buffer_write(buf, (uint8_t *) ":", 1);
  emit_newline(buf);
}

/* Emit a jmp/call/proc/jnf instruction */
void emit_jump_label(buffer_type *buf, op_type type, buffer_type *label) {
    char *c = 0;

    switch (type) {
      case OP_CALL:
          c = "call";
          break;

      case OP_PROC:
          c = "proc";
          break;

      case OP_JMP:
          c = "jmp";
          break;

      case OP_JNF:
          c = "jnf";
          break;

      default:
          fprintf(stderr, "op_type not a known jump instruction %i", type);
          assert(0);
    }

    /* Output the jmp */
    emit_indent(buf);
    buffer_write(buf, (uint8_t*)c, strlen(c));
    buffer_write(buf, (uint8_t*)" ", 1);
    buffer_append(buf, label, -1);
    emit_newline(buf);
}
/* Emit a cond expression */
void emit_cond(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *node, bool allow_tail_call) {

  buffer_type *next_label = 0;
  buffer_type *done_label = 0;

  ins_node_type *clause = 0;

  gc_register_root(compiler->gc, &next_label);
  gc_register_root(compiler->gc, &done_label);

  gen_label(compiler, &done_label);

  emit_comment(buf, "--Cond Start--");

  clause = node->value.stream->head;

  while (clause) {
    node = clause->value.stream->head;

    emit_comment(buf, "----Cond Clause----");

    /* Emit the test */
    emit_stream(compiler, buf, node->value.two.stream1, false);

    emit_op(buf, "not");
    gen_label(compiler, &next_label);
    emit_jump_label(buf, OP_JNF, next_label);

    /* Emit the body */
    emit_stream(compiler, buf, node->value.two.stream2, allow_tail_call);

    /* Emit jump to end */
    emit_jump_label(buf, OP_JMP, done_label);

    emit_label(buf, next_label);

    clause = clause->next;
  }

  emit_comment(buf, "--Cond Fall-Through--");

  /* In the event no case matches, follow our defined stack discipline */
  emit_op(buf, "()");

  emit_label(buf, done_label);
  emit_comment(buf, "--Cond End--");

  gc_unregister_root(compiler->gc, &next_label);
  gc_unregister_root(compiler->gc, &done_label);
}

/* Emit an If */
void emit_if(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *node, bool allow_tail_call) {

  buffer_type *true_label = 0;
  buffer_type *done_label = 0;

  ins_node_type *body = node->value.two.stream2->head; /* If body streams */

  gc_register_root(compiler->gc, &true_label);
  gc_register_root(compiler->gc, &done_label);

  gen_label(compiler, &true_label);
  gen_label(compiler, &done_label);

  emit_comment(buf, "--If Start--");
  emit_stream(compiler, buf, node->value.two.stream1, false);

  emit_jump_label(buf, OP_JNF, true_label);

  /* <false> */
  emit_stream(compiler, buf, body->value.two.stream2, allow_tail_call);

  /* jmp done */
  emit_jump_label(buf, OP_JMP, done_label);

  /* true: */
  emit_comment(buf, "--If true--");
  emit_label(buf, true_label);

  /* <true> */
  emit_stream(compiler, buf, body->value.two.stream1, allow_tail_call);

  /* done: */
  emit_comment(buf, "--If Done--");

  /* emit label */
  emit_label(buf, done_label);

  emit_comment(buf, "--If End--");


  gc_unregister_root(compiler->gc, &done_label);
  gc_unregister_root(compiler->gc, &true_label);
}

/* Handle and(true)/or(false) */
void emit_bool(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *tree, bool allow_tail_call, bool and_or) {

  ins_node_type *exp = 0;
  bool pushed = false;
  bool no_args = true;

  buffer_type *done_label = 0;
  buffer_type *next_label = 0;

  gc_register_root(compiler->gc, &done_label);
  gc_register_root(compiler->gc, &next_label);

  gen_label(compiler, &done_label);

  /* a null stream is possible */
  if (tree && tree->value.stream) {
    exp = tree->value.stream->head;
  }

  emit_comment(buf, "--Bool Operator Start--");

  while(exp) {
    no_args = false;

    /* Tail calls cannot be allowed here */
    pushed = emit_node(compiler, buf, exp, false);

    exp = exp->next;

    // TODO: Look at optimizing this out
    if (!pushed) {
      emit_op(buf, "()");
    }

    if (exp) {
      emit_op(buf, "dup");

      if (and_or) {
        /* and case */
        gen_label(compiler, &next_label);

        emit_jump_label(buf, OP_JNF, next_label);
        emit_jump_label(buf, OP_JMP, done_label);

        emit_label(buf, next_label);
      } else {
        /* or case */
        emit_jump_label(buf, OP_JNF, done_label);
      }

      /* ignore intermediate results */
      emit_op(buf, "drop");
    }
  }

  /* If there were no arguments, treat this as a literal
   * #t or #f */
  if (no_args) {
    if (and_or) {
      emit_op(buf, "#t");
    } else {
      emit_op(buf, "#f");
    }
  }

  emit_label(buf, done_label);

  emit_comment(buf, "--Bool Operator End--");

  gc_unregister_root(compiler->gc, &done_label);
  gc_unregister_root(compiler->gc, &next_label);
}

/* Emit framing code for a lambda */
void emit_lambda(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *node) {

  ins_stream_type *formals = 0; /* Part of the tree, so don't need to watch it. */
  ins_node_type *formal_node = 0;
  bool bind_rest = false;

  buffer_type *proc_label = 0;
  buffer_type *skip_label = 0;

  gc_register_root(compiler->gc, &proc_label);
  gc_register_root(compiler->gc, &skip_label);

  gen_label(compiler, &proc_label);
  gen_label(compiler, &skip_label);

  /* calling convention is ( args ret -- ) */

  /* jmp skip_label */
  emit_jump_label(buf, OP_JMP, skip_label);

  /* proc_label: */
  emit_label(buf, proc_label);

  /* swap  -- flip args and return */
  emit_op(buf, "swap");

  /* output formal binding code */
  emit_comment(buf, "-- Formals --");
  formals = node->value.two.stream1;

  /* If there are no formals, drop the arguments */
  formal_node = formals->head;

  /* Loop until we're at the end of the list we're looking at a () */
  while (formal_node && formal_node->type != STREAM_LITERAL) {

    /* If we see the end of the list here, we're binding anything left in the
       arguments list to this symbol. */
    bind_rest = (formal_node && formal_node->next == 0);

    emit_comment(buf, "----");

    if (bind_rest) {
      /* If we have a single node, bind everything to it. */
      if (formal_node->next) {
        emit_op(buf, "cdr");
      }
    } else {
      emit_op(buf, "dup");
      emit_op(buf, "car");
    }

    emit_literal(buf, formal_node);

    emit_op(buf, "bind");

    formal_node = formal_node->next;

    /* If we're at the last node or binding the rest, don't cdr */
    if (!bind_rest && formal_node && formal_node->type != STREAM_LITERAL) {
      emit_op(buf, "cdr");
    }
  }

  /* Drop the () at the end of the arguments list */
  emit_comment(buf, "----");
  if (!bind_rest) {
    emit_op(buf, "drop");
  }

  /* output body */
  emit_comment(buf, "-- Body --");
  emit_stream(compiler, buf, node->value.two.stream2, true);

  /* swap ret */
  // TODO Add a check for tail call to avoid garbage instructions in the
  // stream
  emit_op(buf, "swap ret");

  /* skip_label: */
  emit_label(buf, skip_label);

  /* proc proc_label: */
  emit_jump_label(buf, OP_PROC, proc_label);

  gc_unregister_root(compiler->gc, &skip_label);
  gc_unregister_root(compiler->gc, &proc_label);
}

/* Emit framing code for a let*. */
void emit_let_star(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *node, bool allow_tail_call) {

  buffer_type *body_label = 0;
  buffer_type *next_label = 0;

  gc_register_root(compiler->gc, &body_label);
  gc_register_root(compiler->gc, &next_label);

  gen_label(compiler, &body_label);
  gen_label(compiler, &next_label);

  emit_comment(buf, "-- Let* --");

  /* Call the label for the let body. */
  if (allow_tail_call) {
    emit_op(buf, "()");
    emit_jump_label(buf, OP_PROC, body_label);
    emit_op(buf, "tail_call_in");
  } else {
    emit_jump_label(buf, OP_CALL, body_label);
    emit_jump_label(buf, OP_JMP, next_label);
  }

  emit_label(buf, body_label);

  /* tail_call_in requires args, but let* doesn't so we need to drop them. */
  if (allow_tail_call) {
    emit_op(buf, "swap drop");
  }

  emit_comment(buf, "-- Binding List--");
  emit_stream(compiler, buf, node->value.two.stream1, false);
  emit_op(buf, "drop"); /* Inefficient, but works */
  emit_comment(buf, "-- Binding List End--");

  emit_comment(buf, "-- Let* Body--");
  emit_stream(compiler, buf, node->value.two.stream2, allow_tail_call);
  emit_comment(buf, "-- Let* Body End--");

  emit_op(buf, "swap ret");

  emit_label(buf, next_label);

  emit_comment(buf, "-- Let* End --");

  gc_unregister_root(compiler->gc, &next_label);
  gc_unregister_root(compiler->gc, &body_label);
}

/* Build a function call */
void emit_call(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *call, bool tail_call) {
  ins_node_type *head = 0;
  bool pushed = false;

  emit_comment(buf, "--Call Start--");

  /* Arugments are always a list */
  emit_op(buf, "()");

  /* Walk arguments and evaluate them */
  head = call->value.two.stream2->head;
  while (head) {
    pushed = emit_node(compiler, buf, head, false);

    /* Always take a slot */
    if (!pushed) {
      emit_op(buf, "()");
    }

    emit_op(buf, "cons");
    head = head->next;
  }

  emit_stream(compiler, buf, call->value.two.stream1, false);

  /* Rely on a vm level hack to make tail calls work */
  if (tail_call) {
    emit_op(buf, "tail_call_in");
  } else {
    emit_op(buf, "call_in");
  }

  emit_comment(buf, "--Call End--");

}

/* Given a literal instrcution node, output it to our buffer */
void emit_literal(buffer_type *buf, ins_node_type *ins) {
  emit_op(buf, ins->value.literal);
}

/* Output a string to the asm buffer */
void emit_string(buffer_type *buf, ins_node_type *ins) {
  char *quote = "\"";

  emit_indent(buf);
  buffer_write(buf, (uint8_t*)quote, 1);
  buffer_write(buf, (uint8_t*)ins->value.literal, strlen(ins->value.literal));
  buffer_write(buf, (uint8_t*)quote, 1);
  emit_newline(buf);
}

/* Emit a quoted structure */
void emit_quoted(buffer_type *buf, ins_stream_type *tree) {
  ins_node_type *head = tree->head;
  bool is_list = false;

  emit_comment(buf, "--Quoted Start--");

  /* Loop through all the nodes in the quoted object */
  while (head) {
    switch (head->type) {
      case STREAM_QUOTED:
        emit_quoted(buf, head->value.stream);
        break;

      case STREAM_LITERAL:
      case STREAM_SYMBOL:
        emit_literal(buf, head);
        break;

      case STREAM_STRING:
        emit_string(buf, head);
        break;

      default:
        fprintf(stderr, "Unknown instructions type %i in stream!\n", head->type);
        break;
    }

    if (is_list) {
      emit_op(buf, "cons");
    }

    head = head->next;

    /* If we get to a second iteration, then we have a quoted list */
    is_list = true;
  }
  emit_comment(buf, "--Quoted End--");
}

/* Emit a record type definition call */
void emit_record_type(compiler_core_type *compiler, buffer_type *buf, ins_stream_type *def) {

  buffer_type *loop_label = 0;
  buffer_type *done_label = 0;

  gc_register_root(compiler->gc, &loop_label);
  gc_register_root(compiler->gc, &done_label);

  emit_comment(buf, "--Record Start--");

  /* output arguments list the same as quoted */
  emit_quoted(buf, def);

  /* output call to record-type-factory */
  emit_op(buf, "s\"record-type-factory\"");
  emit_op(buf, "@");
  emit_op(buf, "call_in"); /* Assumed that this cannot be a tail call */

  /* build binding code */
  emit_comment(buf, "--Record Binding--");

  gen_label(compiler, &loop_label);
  gen_label(compiler, &done_label);

  emit_label(buf, loop_label);

  /* do binding test */
  emit_op(buf, "dup");
  emit_op(buf, "null?");

  emit_jump_label(buf, OP_JNF, done_label);

  emit_op(buf, "dup");

  /* pull pair of the form ( sym . value ) */
  emit_op(buf, "car");

  /* extract symbol and value and bind the two */
  emit_op(buf, "dup");
  emit_op(buf, "cdr");
  emit_op(buf, "swap");
  emit_op(buf, "car");
  emit_op(buf, "bind");

  /* next entry in list */
  emit_op(buf, "cdr");
  emit_jump_label(buf, OP_JMP, loop_label);

  emit_label(buf, done_label);
  emit_comment(buf, "--Record End--");

  gc_unregister_root(compiler->gc, &done_label);
  gc_unregister_root(compiler->gc, &loop_label);
}

/* Emit a single stream structure */
void emit_asm(compiler_core_type *compiler, buffer_type *buf, ins_stream_type *tree) {
  ins_node_type *head = tree->head;

  emit_comment(buf, "--Raw ASM Start--");

  /* Loop through all the nodes in the single object */
  while (head) {
    switch (head->type) {
      case STREAM_ASM_STREAM:
        emit_comment(buf, "----Escape ASM Start----");
        emit_stream(compiler, buf, head->value.stream, false);
        emit_comment(buf, "----Escape ASM End----");
        break;

      default:
        emit_literal(buf, head);
        break;
    }
    head = head->next;
  }
  emit_comment(buf, "--Raw ASM End--");
}

/* Output dual instruction stream ops */
void emit_double(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *node, char *op) {

  emit_stream(compiler, buf, node->value.two.stream1, false);
  emit_stream(compiler, buf, node->value.two.stream2, false);
  emit_op(buf, op);
}

/* Decide how to output an expressione element */
bool emit_node(compiler_core_type *compiler, buffer_type *buf,
  ins_node_type *head, bool allow_tail_call) {
  bool pushed = false;

  /* Process each instruction in the stream */
  switch (head->type) {
    case STREAM_LITERAL:
    case STREAM_SYMBOL:
    case STREAM_OP: /* ASM should be on it's own */
      emit_literal(buf, head);
      pushed = true;
      break;

    case STREAM_STRING:
      emit_string(buf, head);
      pushed = true;
      break;

    case STREAM_QUOTED:
      emit_quoted(buf, head->value.stream);
      pushed = true;
      break;

    case STREAM_RECORD_TYPE:
      emit_record_type(compiler, buf, head->value.stream);
      pushed = true;
      break;

    case STREAM_ASM:
      emit_asm(compiler, buf, head->value.stream);
      pushed = true;
      break;

    case STREAM_LOAD:
      /* Simple load form symbol operation */
      emit_stream(compiler, buf, head->value.stream, false);
      emit_op(buf, "@");
      pushed = true;
      break;

    case STREAM_COND:
      emit_cond(compiler, buf, head, allow_tail_call);
      pushed = true;
      break;

    case STREAM_IF:
      emit_if(compiler, buf, head, allow_tail_call);
      pushed = true;
      break;

    case STREAM_AND:
      emit_bool(compiler, buf, head, allow_tail_call, true);
      pushed = true;
      break;

    case STREAM_OR:
      emit_bool(compiler, buf, head, allow_tail_call, false);
      pushed = true;
      break;

    case STREAM_MATH:
      emit_double(compiler, buf,
        head->value.two.stream2->head,
        head->value.two.stream1->head->value.literal);
      pushed = true;
      break;

    case STREAM_LAMBDA:
      emit_lambda(compiler, buf, head);
      pushed = true;
      break;

    case STREAM_CALL:
      emit_call(compiler, buf, head, allow_tail_call && !head->next);
      pushed = true;
      break;

    case STREAM_BIND:
      emit_double(compiler, buf, head, "bind");
      break;

    case STREAM_STORE:
      emit_double(compiler, buf, head, "!");
      break;

    case STREAM_LET_STAR:
      emit_let_star(compiler, buf, head, allow_tail_call);
      pushed = true;
      break;

    default:
      fprintf(stderr, "Unknown instructions type %i in stream!\n", head->type);
      break;
  }

  return pushed;
}

/* Walk an instruction stream and write it to the buffer in 'pretty' form */
void emit_stream(compiler_core_type *compiler, buffer_type *buf,
  ins_stream_type *tree, bool allow_tail_call) {
  ins_node_type *head = 0;
  bool pushed = false;


  if (tree) {
    head = tree->head;
  }

  while (head) {
    /* Set to true if the node pushes to the stack */
    pushed = emit_node(compiler, buf, head, allow_tail_call && !(head->next));

    head = head->next;

    /* We treat a stream like a begin block, only the
       last node can leave something on the stack. */
    if (head && pushed) {
      emit_op(buf, "drop");
    }
  }

  if (!pushed) {
    emit_op(buf, "()");
  }
}

