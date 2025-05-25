import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    this.setupSmoothScrolling()
    this.setupActiveNavigation()
  }

  setupSmoothScrolling() {
    // Handle all navigation links
    const navLinks = this.element.querySelectorAll('.docs-nav-link')
    
    navLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault()
        const targetId = link.getAttribute('href').substring(1)
        const targetElement = document.getElementById(targetId)
        
        if (targetElement) {
          // Smooth scroll to target
          targetElement.scrollIntoView({
            behavior: 'smooth',
            block: 'start'
          })
          
          // Update active navigation
          this.updateActiveNav(link)
        }
      })
    })
  }

  setupActiveNavigation() {
    // Create intersection observer for sections
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const id = entry.target.id
          const navLink = this.element.querySelector(`a[href="#${id}"]`)
          if (navLink) {
            this.updateActiveNav(navLink)
          }
        }
      })
    }, {
      rootMargin: '-20% 0px -70% 0px',
      threshold: 0.1
    })

    // Observe all sections
    const sections = document.querySelectorAll('[id^="getting-started"], [id^="pipelines"], [id^="connections"], [id^="ai-features"], [id^="monitoring"], [id^="api"], [id^="troubleshooting"], [id^="examples"]')
    sections.forEach(section => observer.observe(section))
  }

  updateActiveNav(activeLink) {
    // Remove active class from all links
    const allLinks = this.element.querySelectorAll('.docs-nav-link')
    allLinks.forEach(link => {
      link.classList.remove('text-blue-600', 'bg-blue-50', 'font-medium')
      link.classList.add('text-gray-600')
    })

    // Add active class to current link
    activeLink.classList.remove('text-gray-600')
    activeLink.classList.add('text-blue-600', 'bg-blue-50', 'font-medium')
  }
}
