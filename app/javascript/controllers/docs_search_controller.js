import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.debounceTimer = null
  }

  disconnect() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }
  }

  search() {
    // Clear existing timer
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }

    // Debounce search for better performance
    this.debounceTimer = setTimeout(() => {
      this.performSearch()
    }, 300)
  }

  performSearch() {
    const query = this.inputTarget.value.toLowerCase().trim()
    
    if (query === "") {
      this.clearHighlights()
      return
    }

    // Get all content sections
    const sections = document.querySelectorAll('[id^="getting-started"], [id^="pipelines"], [id^="connections"], [id^="ai-features"], [id^="monitoring"], [id^="api"], [id^="troubleshooting"], [id^="examples"]')
    
    this.clearHighlights()
    
    sections.forEach(section => {
      const text = section.textContent.toLowerCase()
      if (text.includes(query)) {
        this.highlightSection(section)
      }
    })
  }

  highlightSection(section) {
    section.style.backgroundColor = "rgba(59, 130, 246, 0.1)"
    section.style.border = "2px solid rgba(59, 130, 246, 0.3)"
    section.style.borderRadius = "8px"
    section.style.transition = "all 0.3s ease"
  }

  clearHighlights() {
    const sections = document.querySelectorAll('[id^="getting-started"], [id^="pipelines"], [id^="connections"], [id^="ai-features"], [id^="monitoring"], [id^="api"], [id^="troubleshooting"], [id^="examples"]')
    
    sections.forEach(section => {
      section.style.backgroundColor = ""
      section.style.border = ""
      section.style.borderRadius = ""
    })
  }

  // Handle input events
  inputTarget_changed() {
    this.search()
  }
}
