/* These functions define the primitives for physical memory access.
 * They depend on the XLEN of the architecture.
 *
 * They also depend on the type of metadata that is read and written
 * to physical memory.  For models that do not require this metadata,
 * a unit type can be used.
 *
 * The underlying __read_mem and __write_mem functions are from the
 * Sail library.  The metadata primitives __{Read,Write}RAM_Meta are
 * in prelude_mem_metadata.
 */

val write_ram : forall 'n, 'n > 0. (write_kind, xlenbits, atom('n), bits(8 * 'n), mem_meta) -> bool effect {wmv, wmvt}
function write_ram(wk, addr, width, data, meta) = {
  /* Write out metadata only if the value write succeeds.
   * It is assumed for now that this write always succeeds;
   * there is currently no return value.
   * FIXME: We should convert the external API to consume
   * the value along with the metadata to ensure atomicity.
   */
  let ret : bool = __write_mem(wk, sizeof(xlen), addr, width, data);
  if ret then __WriteRAM_Meta(addr, width, meta);
  ret
}

val write_ram_ea : forall 'n, 'n > 0 . (write_kind, xlenbits, atom('n)) -> unit effect {eamem}
function write_ram_ea(wk, addr, width) =
  __write_mem_ea(wk, sizeof(xlen), addr, width)

/* FIXME: Make this also return the metadata, which will also require external API changes. */
val read_ram : forall 'n, 'n > 0.  (read_kind, xlenbits, atom('n)) -> bits(8 * 'n) effect {rmem}
function read_ram(rk, addr, width) =
  __read_mem(rk, sizeof(xlen), addr, width)

val __TraceMemoryWrite : forall 'n 'm. (atom('n), bits('m), bits(8 * 'n)) -> unit
val __TraceMemoryRead  : forall 'n 'm. (atom('n), bits('m), bits(8 * 'n)) -> unit
