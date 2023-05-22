import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["linkedIn", "twitter", "facebook", "whatsapp", "pinterest"];
  static values = { title: String };
  connect() {
    let postUrl = encodeURI(document.location.href)
    this.linkedInTarget.setAttribute('href', `https://www.linkedin.com/sharing/share-offsite/?url=${postUrl}`);
    this.twitterTarget.setAttribute('href', `https://twitter.com/intent/tweet/?text=${this.titleValue}&url=${postUrl}&via=educationcourier`);
    this.facebookTarget.setAttribute('href', `https://www.facebook.com/sharer/sharer.php?u=${postUrl}`);
    this.whatsappTarget.setAttribute('href', `https://api.whatsapp.com/send?text=${this.titleValue} ${postUrl}`);
    this.pinterestTarget.setAttribute('href', `https://pinterest.com/pin/create/button/?url=${postUrl}&description=${this.titleValue}`);
  }
}
