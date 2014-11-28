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

/* Emit an If */
void emit_if(compiler_core_type *compiler, buffer_type *test_buffer,
  buffer_type *true_buffer, buffer_type *false_buffer) {
  
  buffer_type *true_label = 0;
  buffer_type *done_label = 0;

  gc_register_root(compiler->gc, &true_label);
  gc_register_root(compiler->gc, &done_label);

  gen_label(compiler, &true_label);
  gen_label(compiler, &done_label);


  /* <test> jnf true */
  /*buffer_write(test_buffer, (uint8_t *)"jnf ", 5);
  buffer_append(test_buffer, true_label, -1);
  emit_newline(test_buffer);*/
  emit_comment(test_buffer, "If TEST");
  emit_jump_label(test_buffer, OP_JNF, true_label);

  /* <false> jmp done */
  buffer_append(test_buffer, false_buffer, -1);

  emit_jump_label(test_buffer, OP_JMP, done_label);
  /*buffer_write(test_buffer, (uint8_t *)" jmp ", 5);
  buffer_append(test_buffer, done_label, -1);
  emit_newline(test_buffer);*/

  /* true: */
  emit_comment(test_buffer, "If TRUE");
  buffer_append(test_buffer, true_label, -1);
  buffer_write(test_buffer, (uint8_t *) ":", 1);
  emit_newline(test_buffer);
 
  /* <true> */ 
  buffer_append(test_buffer, true_buffer, -1);
  emit_newline(test_buffer);
 
  /* done: */
  emit_comment(test_buffer, "If DONE");
  buffer_append(test_buffer, done_label, -1);
  buffer_write(test_buffer, (uint8_t *) ":", 1);
  emit_newline(test_buffer);
  
  emit_comment(test_buffer, "END IF");

  
  gc_unregister_root(compiler->gc, &done_label);
  gc_unregister_root(compiler->gc, &true_label);
}

/* Emit framing code for a lambda */
void emit_lambda(compiler_core_type *compiler, buffer_type *output,
  buffer_type *formals, buffer_type *body) {

  buffer_type *proc_label = 0;
  buffer_type *skip_label = 0;

  gc_register_root(compiler->gc, &proc_label);
  gc_register_root(compiler->gc, &skip_label);

  gen_label(compiler, &proc_label);
  gen_label(compiler, &skip_label);

  /* calling convention is ( args ret -- ) */


  /* output a jump so we don't execute the lambda during
     definition */

  /* jmp skip_label */
  buffer_write(output, (uint8_t *)" jmp ", 5);
  buffer_append(output, skip_label, -1);
  emit_newline(output);

  /* proc_label: */
  buffer_append(output, proc_label, -1);
  buffer_write(output, (uint8_t *)":", 1);
  emit_newline(output);

  /* swap */
  emit_op(output, "swap");

  /* output formal binding code */
  buffer_append(output, formals, -1);
  emit_newline(output);

  /* output body */
  buffer_append(output, body, -1);
  emit_newline(output);

  /* swap ret */
  emit_op(output, "swap ret");

  /* skip_label: */
  buffer_append(output, skip_label, -1);
  buffer_write(output, (uint8_t *)":", 1);
  emit_newline(output);

  /* proc proc_label: */
  buffer_write(output, (uint8_t *)" proc ", 6);
  buffer_append(output, proc_label, -1);
  emit_newline(output);
  emit_newline(output);

  gc_unregister_root(compiler->gc, &skip_label);
  gc_unregister_root(compiler->gc, &proc_label);
}

/* Given a literal instrcution node, output it to our buffer */
void emit_literal(buffer_type *buf, ins_node_type *ins) {
  emit_op(buf, ins->value.literal);
}

/* Emit a quoted structure */
void emit_quoted(buffer_type *buf, ins_stream_type *tree) {
  ins_node_type *head = tree->head;
  bool is_list = false;

  /* Loop through all the nodes in the quoted object */
  while (head) {
    emit_literal(buf, head);

    if (is_list) {
      emit_op(buf, "cons");
    }

    head = head->next;
    
    /* If we get to a second iteration, then we have a quoted list */
    is_list = true;
  }
}

/* Emit a single stream structure */
void emit_single(buffer_type *buf, ins_stream_type *tree) {
  ins_node_type *head = tree->head;

  /* Loop through all the nodes in the single object */
  while (head) {
    emit_literal(buf, head);
    head = head->next;
  }
}
/* Output dual instruction stream ops */
void emit_double(buffer_type *buf, ins_node_type *node, char *op) {

  emit_stream(buf, node->value.two.stream1);
  emit_stream(buf, node->value.two.stream2);
  emit_op(buf, op);
}

/* Walk an instruction stream and write it to the buffer in 'pretty' form */
void emit_stream(buffer_type *buf, ins_stream_type *tree) {
  ins_node_type *head = 0;
  bool pushed = false; 


  if (tree) { 
    head = tree->head;
  }

  emit_comment(buf, "--Begin Start--");

  while (head) {
    /* Set to true if the node pushes to the stack */
    pushed = false;

    /* Process each instruction in the stream */
    switch (head->type) {
      case STREAM_LITERAL:
      case STREAM_SYMBOL:
      case STREAM_OP: /* ASM should be on it's own */
        emit_literal(buf, head);
        pushed = true;
        break;

      case STREAM_QUOTED:
        emit_comment(buf, "--Quoted Start--");
        emit_single(buf, head->value.stream);
        emit_comment(buf, "--Quoted End--");
        pushed = true;
        break;

      case STREAM_ASM:
        emit_comment(buf, "--Raw ASM Start--");
        emit_single(buf, head->value.stream);
        emit_comment(buf, "--Raw ASM End--");
        break;

      case STREAM_LOAD:
        /* Simple load form symbol operation */
        emit_comment(buf, "--Load Start--");
        emit_stream(buf, head->value.stream);
        emit_op(buf, "@");
        emit_comment(buf, "--Load End--");
        pushed = true;
        break;

      case STREAM_BIND:
        emit_comment(buf, "--Bind Start--");
        emit_double(buf, head, "bind");
        emit_comment(buf, "--Bind End--");
        break;

      case STREAM_STORE:
        emit_comment(buf, "--Store Start--");
        emit_double(buf, head, "!");
        emit_comment(buf, "--Store End--");
        break;

      default:
        fprintf(stderr, "Unknown instructions type %i in stream!\n", head->type);
        break;
    }

    head = head->next;

    /* We treat a stream like a begin block, only the
       last node can leave something on the stack. */
    if (head && pushed) {
      emit_op(buf, "drop");
    }
  }
  
  emit_comment(buf, "--Begin End--");
}

