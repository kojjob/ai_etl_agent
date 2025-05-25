import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobileMenu", "mobileButton", "hamburger", "close"]
  static classes = ["scrolled"]

  connect() {
    this.handleScroll = this.handleScroll.bind(this)
    this.mobileMenuOpen = false
    
    // Listen for scroll events to change navbar appearance
    window.addEventListener('scroll', this.handleScroll)
    
    // Close mobile menu when clicking outside
    document.addEventListener('click', this.closeOnOutsideClick.bind(this))
    
    // Close mobile menu on window resize if it's open
    window.addEventListener('resize', this.closeOnResize.bind(this))
    
    // Handle anchor link clicks for smooth scrolling
    this.handleAnchorClicks()
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll)
    document.removeEventListener('click', this.closeOnOutsideClick.bind(this))
    window.removeEventListener('resize', this.closeOnResize.bind(this))
  }

  handleScroll() {
    const scrolled = window.scrollY > 50
    
    if (scrolled) {
      this.element.classList.add('bg-white/98', 'shadow-lg')
      this.element.classList.remove('bg-white/95')
    } else {
      this.element.classList.add('bg-white/95')
      this.element.classList.remove('bg-white/98', 'shadow-lg')
    }
  }

  toggleMobile(event) {
    event.preventDefault()
    event.stopPropagation()
    
    this.mobileMenuOpen = !this.mobileMenuOpen
    
    if (this.mobileMenuOpen) {
      this.openMobileMenu()
    } else {
      this.closeMobileMenu()
    }
  }

  openMobileMenu() {
    this.mobileMenuTarget.style.maxHeight = this.mobileMenuTarget.scrollHeight + 'px'
    this.hamburgerTarget.classList.add('hidden')
    this.closeTarget.classList.remove('hidden')
    this.mobileButtonTarget.setAttribute('aria-expanded', 'true')
    
    // Prevent body scroll
    document.body.classList.add('overflow-hidden')
  }

  closeMobileMenu() {
    this.mobileMenuTarget.style.maxHeight = '0px'
    this.hamburgerTarget.classList.remove('hidden')
    this.closeTarget.classList.add('hidden')
    this.mobileButtonTarget.setAttribute('aria-expanded', 'false')
    this.mobileMenuOpen = false
    
    // Allow body scroll
    document.body.classList.remove('overflow-hidden')
  }

  closeOnOutsideClick(event) {
    if (this.mobileMenuOpen && !this.element.contains(event.target)) {
      this.closeMobileMenu()
    }
  }

  closeOnResize() {
    if (window.innerWidth >= 768 && this.mobileMenuOpen) {
      this.closeMobileMenu()
      document.body.classList.remove('overflow-hidden')
    }
  }

  handleAnchorClicks() {
    // Find all anchor links within the navbar
    const anchorLinks = this.element.querySelectorAll('a[href^="#"]')
    
    anchorLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        const targetId = link.getAttribute('href').substring(1)
        const targetElement = document.getElementById(targetId)
        
        if (targetElement) {
          e.preventDefault()
          
          // Close mobile menu if open
          if (this.mobileMenuOpen) {
            this.closeMobileMenu()
          }
          
          // Smooth scroll to target with offset for fixed navbar
          const navbarHeight = this.element.offsetHeight
          const targetPosition = targetElement.offsetTop - navbarHeight - 20
          
          window.scrollTo({
            top: targetPosition,
            behavior: 'smooth'
          })
        }
      })
    })
  }
}
