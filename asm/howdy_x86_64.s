# Copyright 2010-2026 Dustin Kirkland
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Print a howdy greeting to stdout via Linux x86_64 write syscall, then exit.

.intel_syntax noprefix

.section .data
msg:    .ascii "    ====> Assembly: Howdy!\n"
.equ msglen, . - msg

.section .text
.global _start
_start:
    # write(1, msg, msglen)
    mov     rax, 1              # syscall: write
    mov     rdi, 1              # fd = stdout
    lea     rsi, [rip + msg]    # buf = address of msg
    mov     rdx, msglen         # count
    syscall

    # exit(0)
    mov     rax, 60             # syscall: exit
    xor     rdi, rdi            # status = 0
    syscall
