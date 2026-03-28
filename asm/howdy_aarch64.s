// Copyright 2010-2026 Dustin Kirkland
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Print a howdy greeting to stdout via Linux AArch64 write syscall, then exit.

.section .data
msg:    .ascii "    ====> Assembly: Howdy!\n"
.equ msglen, . - msg

.section .text
.global _start
_start:
    // write(1, msg, msglen)
    adrp    x1, msg             // x1 = page base of msg
    add     x1, x1, :lo12:msg  // x1 = exact address of msg
    mov     x2, #msglen         // count
    mov     x0, #1              // fd = stdout
    mov     x8, #64             // syscall: write
    svc     #0

    // exit(0)
    mov     x0, #0              // status = 0
    mov     x8, #93             // syscall: exit
    svc     #0
