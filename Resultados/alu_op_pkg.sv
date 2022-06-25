package alu_op_pkg;

typedef enum logic[0:4]{NOP,
                        ADD,
                        SUB,
                        SLL,
                        SLT,
                        SLTU,
                        XOR,
                        SRL,
                        SRA,
                        OR,
                        AND,
                        MUL,
                        MULH,
                        MULHSU,
                        MULHU,
                        DIV,
                        DIVU,
                        REM,
                        REMU} ALU_op_t;
endpackage