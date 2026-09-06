declare module "*.elm" {
  namespace Elm {
    namespace Main {
      interface Init {
        init(options: { node: HTMLElement | null }): App;
      }
    }
  }

  export const Elm: {
    Main: Elm.Main.Init;
  };
}
