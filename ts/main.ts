import { Elm } from "~/elm/Main.elm";
import * as Strudel from "@strudel/web";
import "~/css/style.css";

const app = Elm.Main.init({
  node: document.querySelector("#elm-app"),
});

Strudel.initStrudel({
  prebake: () => Strudel.samples("github:tidalcycles/dirt-samples"),
});

if (app.ports && app.ports.outgoing) {
  app.ports.outgoing.subscribe(async ({ tag }) => {
    switch (tag) {
      case "PLAY":
        Strudel.s("bd sn bd sn, hh*8").play();
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
