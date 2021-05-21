import { Controller } from "stimulus";

export default class extends Controller {
static targets = ["toggleable", "sideNavContainer", "mainSectionContainer"];

  toggle() {
    this.toggleableTarget.classList.toggle("isHidden");
  }

  navShowHide() {
      this.sideNavContainerTarget.classList.toggle('isHidden')
      this.mainSectionContainerTarget.classList.toggle('leftPadding')
  }
}
