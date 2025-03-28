.section ".text"
// enter busy loop
_start:
  wfe
  b _start
