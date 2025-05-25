import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.isOpen = false
    
    // Close dropdown when clicking outside
    document.addEventListener('click', this.closeOnOutsideClick.bind(this))
    
    // Close dropdown on escape key
    document.addEventListener('keydown', this.closeOnEscape.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.closeOnOutsideClick.bind(this))
    document.removeEventListener('keydown', this.closeOnEscape.bind(this))
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    
    if (this.isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.menuTarget.classList.remove('opacity-0', 'invisible', 'translate-y-1')
    this.menuTarget.classList.add('opacity-100', 'visible', 'translate-y-0')
    this.isOpen = true
    
    // Focus first menu item for accessibility
    const firstMenuItem = this.menuTarget.querySelector('a, button')
    if (firstMenuItem) {
      firstMenuItem.focus()
    }
  }

  close() {
    this.menuTarget.classList.add('opacity-0', 'invisible', 'translate-y-1')
    this.menuTarget.classList.remove('opacity-100', 'visible', 'translate-y-0')
    this.isOpen = false
  }

  closeOnOutsideClick(event) {
    if (this.isOpen && !this.element.contains(event.target)) {
      this.close()
    }
  }

  closeOnEscape(event) {
    if (this.isOpen && event.key === 'Escape') {
      this.close()
    }
  }
}
