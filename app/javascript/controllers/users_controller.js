import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  displayUserSummary(e) {
    let role = e.target.value
    if (role != 'blogger')
      document.getElementById('user-summary').classList.add('d-none');
    else
      document.getElementById('user-summary').classList.remove('d-none');
  }
}
