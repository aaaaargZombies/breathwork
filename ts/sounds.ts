import * as Strudel from "@strudel/web";

const beatsPerCycle = (p: Pattern): number =>
  Object.values(p).reduce((a, b) => a + b);

const buildCycle =
  (f: (entry: [string, number], index: number) => number[]) => (p: Pattern) => {
    const a = Object.entries(p)
      .filter(([_, n]) => Boolean(n))
      .flatMap(f);
    return Strudel.sequence(...a);
  };

export const make = (p: Pattern) => {
  const cycle = buildCycle(([_key, n], i) => Array(n).fill(i))(p);
  const counter = Strudel.note(cycle.add(2))
    .scale("C:minor")
    .sound("dantranh_vibrato")
    .postgain(0.8);

  // silent until first beat of cycle
  const signalChange = buildCycle(([_key, n], _i) =>
    n < 1 ? [] : [2, ...Array(n - 1).fill("~")],
  )(p);
  const dings = Strudel.note(signalChange).sound("handbells").postgain(1);

  return Strudel.stack(counter, dings).slow(beatsPerCycle(p) * 2);
};
