#include "vm_internal.h"

void output_pair(FILE *fout, object_type *pair) {
    int flag = 0;
    object_type *car = 0;
    int length = 0;

    fprintf(fout, "(");

    do {
        /* print a space only if we are not on
           the first pair */
        if(flag) {
            fprintf(fout, " ");
        }

        /* extract the car and cdr */
        car = pair->value.pair.car;
        pair = pair->value.pair.cdr;

        /* output the car */
        output_object(fout, car);

        flag = 1;
        length ++;

    } while(pair && pair->type == PAIR && length < OUTPUT_MAX_LENGTH);


    /* print a . if need one */
    if(!pair || pair->type != EMPTY) {
        fprintf(fout, " . ");
        output_object(fout, pair);
    }


    fprintf(fout,")");
}

/* characters are stored in UTF-32 internally while
   strings and io should be in UTF-8 */
void output_char(FILE *fout, object_type *character) {
    /* 7 byte output buffer (UTF-8 maxes out at 6 */
    char char_buf[] = {0,0,0, 0,0,0, 0};

    /* encode the string in utf8 */
    utf8_encode_char(char_buf, character->value.character);

    fprintf(fout, "%s", char_buf);
    /* fprintf(fout, "#\\%s", char_buf); */

    /* fprintf(fout, "<%x>", character->value.character); */
}

void output_vector(FILE *fout, object_type *vector) {
    vm_int index = 0;

    /* walk all the objects in this vector and
       output them */
    fprintf(fout, "#(");

    for(index = 0; index < vector->value.vector.length; index++) {
        if(index > 0) {
            fprintf(fout, " ");
        }
        output_object(fout,
                      vector->value.vector.vector[index]);
    }

    fprintf(fout, ")");
}

void output_byte_vector(FILE *fout, object_type *vector) {
    vm_int index = 0;

    /* walk all the objects in this vector and
       output them */
    fprintf(fout, "#u8(");

    for(index = 0; index < vector->value.vector.length; index++) {
        if(index > 0) {
            fprintf(fout, " ");
        }
        fprintf(fout, "%u", vector->value.byte_vector.vector[index]);
    }

    fprintf(fout, ")");
}

/* display a given object to stdout */
void output_object(FILE *fout, object_type *obj) {
    env_type *env = 0;
    static int depth = 0;

    depth++;

    if (depth >= OUTPUT_MAX_DEPTH) {
      fprintf(fout, " ...");
      depth--;
      return;
    }

    /* make sure we have an object */
    if(!obj) {
        fprintf(fout, "<nil>");
        return;
    }

    switch(obj->type) {

    case FIXNUM: /* deal with a standard fixnum */
        fprintf(fout, "%" PRIi64, obj->value.integer);
        break;

    case EMPTY: /* The object is an empty pair */
        fprintf(fout, "()");
        break;

    case PAIR:
        output_pair(fout, obj);
        break;

    case CHAR:
        output_char(fout, obj);
        break;

    case STRING:
    case SYMBOL:
        fprintf(fout, "%s", obj->value.string.bytes);
        break;

    case VECTOR:
        output_vector(fout, obj);
        break;

    case BYTE_VECTOR:
        output_byte_vector(fout, obj);
        break;

    case BOOL:
        if(obj->value.boolean) {
            fprintf(fout, "#t");
        } else {
            fprintf(fout, "#f");
        }
        break;

    case CLOSURE:
        env = (env_type *)obj->value.closure;

        fprintf(fout, "{");
        while (env) {
          fprintf(fout, "<CLOSURE %p:%p(%p) -> %p ", (void *)obj,
                  (void *)env,
                  (void *)env->bindings,
                  (void *)env->parent);
          hash_info(env->bindings);
          fprintf(fout, ">\n");
          env = env->parent;
        }
        fprintf(fout, "}");

        break;

    case LIBRARY:
        fprintf(fout, "<LIBRARY %p:%p #%"PRIi64">", (void *)obj,
                (void *)obj->value.library.handle, obj->value.library.func_count);
        break;

    default:
        fprintf(fout, "<Unkown Object %p>", (void *)obj);
        break;
    }

    depth--;
}
