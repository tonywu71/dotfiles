// Opened by a key (mod.open:ask-close-tab). Closes the focused tab, but asks
// first when it has more than one pane. Hands the asking to the shipped
// confirm dialog, then closes itself.
import { View, div } from "gpui-kit";
import { checking, closeOverlay, focused, openOverlay, panes, props, run } from "herdr";

export default class AskCloseTab extends View {
  init() {
    if (checking()) return;
    closeOverlay(props().overlay);
    const tab = focused()?.tab;
    if (!tab) return;
    const paneCount = panes().filter((pane) => pane.tab === tab).length;
    // One pane: close as before (Herdr still asks if it is the space's last tab).
    if (paneCount <= 1) {
      run("tab.close", { id: tab });
      return;
    }
    openOverlay({
      mod: "confirm",
      kind: "dialog",
      width: 360,
      height: 150,
      props: {
        title: "Close tab?",
        detail: `It has ${paneCount} panes. Their terminals will end.`,
        command: { name: "tab.close", args: { id: tab, confirmed: true } },
      },
    });
  }

  render() {
    return div();
  }
}
