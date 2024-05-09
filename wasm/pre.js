/* eslint-disable @typescript-eslint/dot-notation */
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error

Module["TOTAL_MEMORY"] = 65536;
Module["TOTAL_STACK"] = 32768;

Module["preInit"] = function () {
  ASMJS_PAGE_SIZE = 65536;
  MIN_TOTAL_MEMORY = 65536;
};
