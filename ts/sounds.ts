import * as Strudel from "@strudel/web";

type Pattern = {
  "0_breatheIn": number;
  "1_holdIn": number;
  "2_breatheOut": number;
  "3_pauseOut": number;
};

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
  const counter = Strudel.note(cycle)
    .scale("C:minor")
    .s("wt_birds")
    .lpf(Strudel.perlin.range(100, 1000).slow(8))
    .lpenv(-3)
    .lpa(0.5)
    .room(0.9)
    .roomsize(1)
    .fast(2)
    .postgain(0.9);

  // silent until first beat of cycle
  const signalChange = buildCycle(([_key, n], _i) =>
    n < 1 ? [] : [2, ...Array(n - 1).fill("~")],
  )(p);
  const dings = Strudel.note(signalChange).sound("bleep").postgain(0.9);

  return Strudel.stack(counter, dings).slow(beatsPerCycle(p) * 2);
};
