#include "vm_instructions_internal.h"

/* load a file and store it in a single string */
void op_slurp(vm_internal_type *vm) {
    object_type *obj = 0;

    vm->reg1 = obj = vm_pop(vm);

    if (!obj || obj->type != STRING) {
        throw(vm, "Slurp file name not a string!", 1, obj);

    } else {
    
        /* load the file */
        vm_load_buf(vm, obj->value.string.bytes, &vm->reg1);
        
        vm_push(vm, vm->reg1);
    }
}

/* a crude output operations */
void op_output(vm_internal_type *vm) {
    object_type *obj = 0;

    vm->reg1 = obj = vm_pop(vm);
    vm_output_object(stdout, obj);
}

/* open a file and leave the file descriptor on the stack */
void op_open(vm_internal_type *vm) {
    object_type *write = 0;
    object_type *path = 0;
    int fd = 0;
    char *err = 0;

    vm->reg1 = write = vm_pop(vm);
    vm->reg2 = path = vm_pop(vm);

    if (!write || write->type != BOOL ) {
        throw(vm, "Open expected a boolean for write!", 1, write);
    } else if (!path || path->type != STRING) {
        throw(vm, "Open expected a string for path!", 1, path);
    } else {
        if (write->value.boolean) {
            fd = open(path->value.string.bytes, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        } else {
            fd = open(path->value.string.bytes, O_RDONLY);
        }

        /* Allocate an integer for the file descriptor. */
        vm->reg1 = vm_alloc(vm, FIXNUM);
        vm->reg1->value.integer = fd;

        if (fd < 0) {
            err = strerror(errno);
            
            vm->reg1->value.integer = errno;
            vm->reg2 = vm_make_string(vm, err, strlen(err));

            throw (vm, "There was an error opening the file", 2, vm->reg1, vm->reg2);
        } else {
            vm_push(vm, vm->reg1);
        }
    }
}

/* close a file */
void op_close(vm_internal_type *vm) {
    object_type *fd_obj = 0;
    int res = 0; 
    char *err = 0;

    vm->reg1 = fd_obj = vm_pop(vm);

    if (!fd_obj || fd_obj->type != FIXNUM) {
        throw(vm, "Close expects and integer file descriptor!", 1, fd_obj); 
        return;
    }

    res = close(fd_obj->value.integer);

    if (res < 0) {
        err = strerror(errno);
        
        vm->reg1 = vm_alloc(vm, FIXNUM);
        vm->reg1->value.integer = errno;

        vm->reg2 = vm_make_string(vm, err, strlen(err));

        throw (vm, "There was an error closing the file", 2, vm->reg1, vm->reg2);
    }
}

/* write to a file descriptor */
void op_fd_write(vm_internal_type *vm) {
    object_type *u8 = 0;
    object_type *num = 0;
    object_type *fd = 0;
    
    vm_int written = 0;
    char *err = 0;

    vm->reg1 = fd = vm_pop(vm);
    vm->reg2 = num = vm_pop(vm);
    vm->reg3 = u8 = vm_pop(vm);

    if (!fd || fd->type != FIXNUM) {
        throw(vm, "Read expected file descriptor!", 1, fd);
        return;
    } 

    if (!num || num->type != FIXNUM) {
        throw(vm, "Read expected a number of bytes to read!", 1, num);
        return;
    }

    if (!u8 || u8->type != BYTE_VECTOR) {
        throw(vm, "Read expected a byte vector!", 1, u8);
        return;
    }
    
    written = write(fd->value.integer, u8->value.byte_vector.vector, num->value.integer);

    vm->reg1 = vm_alloc(vm, FIXNUM);
    vm->reg1->value.integer = written;

    if (written < 0) {
        err = strerror(errno);
        
        vm->reg1 = vm_alloc(vm, FIXNUM);
        vm->reg1->value.integer = errno;

        vm->reg2 = vm_make_string(vm, err, strlen(err));

        throw(vm, "An error ocurred while writing.", 2, vm->reg1, vm->reg2);  
    } else if (written != num->value.integer) { 
        throw(vm, "Did not write all bytes.", 1, vm->reg1);
    } else {
        vm_push(vm, vm->reg1);
    } 
}

/* read from a file desciptor */
void op_fd_read(vm_internal_type *vm) {
    object_type *u8 = 0;
    object_type *num = 0;
    object_type *fd = 0;
    
    vm_int bytes_read = 0;
    char *err = 0;


    vm->reg1 = fd = vm_pop(vm);
    vm->reg2 = num = vm_pop(vm);

    if (!fd || fd->type != FIXNUM) {
        throw(vm, "Read expected a file descriptor!", 1, fd);
        return;
    }

    if (!num || num->type != FIXNUM) {
        throw(vm, "Read expected a number of bytes to read!", 1, num);
        return;
    }

    vm->reg3 = u8 = vm_make_byte_vector(vm, num->value.integer);
    
    bytes_read = read(fd->value.integer, u8->value.byte_vector.vector, num->value.integer);

    if (bytes_read < 0) {
        err = strerror(errno);
        
        vm->reg1 = vm_alloc(vm, FIXNUM);
        vm->reg1->value.integer = errno;

        vm->reg2 = vm_make_string(vm, err, strlen(err));

        throw(vm, "An error ocurred while reading.", 2, vm->reg1, vm->reg2);  
    } else {
        /* Hackish way to restrict u8 to the number of bytes read. */
        vm->reg3->value.byte_vector.length = bytes_read;

        vm_push(vm, vm->reg3);
    }  
}

