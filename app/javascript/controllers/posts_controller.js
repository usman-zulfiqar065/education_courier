import { Controller } from "@hotwired/stimulus"
import 'quill'
export default class extends Controller {
 static targets = ["editor"]
  connect() {
    this.quill = new Quill(this.editorTarget, {
      theme: 'snow'
    });
    var input_field = document.getElementById("post_content")
    this.quill.container.firstChild.innerHTML = input_field.value;
    this.quill.on('text-change', (delta, oldDelta, source) => {
      document.getElementById("post_content").value = this.quill.container.firstChild.innerHTML;
    });
  }

  disconnect() {
    if (this.quill) {
      this.quill = null;
    }
  }
}