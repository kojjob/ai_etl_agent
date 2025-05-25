import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "submit"]

  connect() {
    this.isSubmitting = false
  }

  submit(event) {
    event.preventDefault()
    
    if (this.isSubmitting) return
    
    const email = this.emailTarget.value.trim()
    
    if (!this.isValidEmail(email)) {
      this.showError("Please enter a valid email address")
      return
    }

    this.startSubmitting()
    
    // For now, simulate successful subscription
    // TODO: Replace with actual API endpoint when newsletter service is implemented
    setTimeout(() => {
      this.handleSuccess()
    }, 1000)
    
    // Example of how to implement actual API call:
    /*
    fetch('/newsletter/subscribe', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ email: email })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.handleSuccess()
      } else {
        this.handleError(data.message || "Failed to subscribe")
      }
    })
    .catch(error => {
      this.handleError("Network error. Please try again.")
    })
    */
  }

  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  startSubmitting() {
    this.isSubmitting = true
    this.submitTarget.textContent = "Subscribing..."
    this.submitTarget.disabled = true
    this.emailTarget.disabled = true
  }

  handleSuccess() {
    this.showSuccess("Thanks for subscribing!")
    this.emailTarget.value = ""
    this.resetForm()
  }

  handleError(message = "Something went wrong. Please try again.") {
    this.showError(message)
    this.resetForm()
  }

  resetForm() {
    setTimeout(() => {
      this.isSubmitting = false
      this.submitTarget.textContent = "Subscribe"
      this.submitTarget.disabled = false
      this.emailTarget.disabled = false
    }, 2000)
  }

  showSuccess(message) {
    this.showNotification(message, "success")
  }

  showError(message) {
    this.showNotification(message, "error")
  }

  showNotification(message, type) {
    // Create notification element
    const notification = document.createElement('div')
    notification.className = `fixed top-4 right-4 z-50 px-6 py-3 rounded-lg shadow-lg transform translate-x-full transition-transform duration-300 ${
      type === 'success' 
        ? 'bg-green-600 text-white' 
        : 'bg-red-600 text-white'
    }`
    notification.textContent = message
    
    document.body.appendChild(notification)
    
    // Animate in
    setTimeout(() => {
      notification.classList.remove('translate-x-full')
    }, 100)
    
    // Animate out and remove
    setTimeout(() => {
      notification.classList.add('translate-x-full')
      setTimeout(() => {
        document.body.removeChild(notification)
      }, 300)
    }, 3000)
  }
}
