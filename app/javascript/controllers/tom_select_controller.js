import {Controller} from "@hotwired/stimulus"
import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    new TomSelect("select", {
      sortField: {
        field: "text",
        direction: "asc"
      }
    });
  }
}
