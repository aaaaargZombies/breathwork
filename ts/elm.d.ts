declare module "*.elm" {
  namespace Elm {
    namespace Main {
      interface App {
        ports: {
          outgoing: {
            subscribe(callback: (data: Outgoing) => void): void;
          };
          incoming: {
            send(data: Incomming): void;
          };
        };
      }
      interface Init {
        init(options: { node: HTMLElement | null }): App;
      }
    }
  }

  export const Elm: {
    Main: Elm.Main.Init;
  };
}

type Outgoing = { tag: "PLAY"; data: null } | { tag: "STOP"; data: null };
