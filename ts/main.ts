import * as Strudel from "@strudel/web";
import "~/css/style.css";
import { Elm } from "~/elm/Main.elm";
import * as Sounds from "./sounds.ts";

const app = Elm.Main.init({
  node: document.querySelector("#elm-app"),
});

const repl = await Strudel.initStrudel({
  prebake: async () => {
    await Strudel.samples("github:tidalcycles/dirt-samples");
  },
});

if (app.ports && app.ports.outgoing) {
  app.ports.outgoing.subscribe(async ({ tag, data }) => {
    switch (tag) {
      case "PLAY":
        Sounds.make(repl.setCps, data).play();
        break;

      case "STOP":
        Strudel.hush();
        break;

      default:
        exhaustive("❌ Unknown tag from Elm:", tag);
        break;
    }
  });
}

const exhaustive = (msg: string, supriseCase: never) => {
  console.error(msg, supriseCase);
};
