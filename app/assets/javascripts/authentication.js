document.addEventListener('DOMContentLoaded', function() {
  // Form validation and enhancement
  const forms = document.querySelectorAll('form');
  
  forms.forEach(form => {
    if (!form) return;
    
    const inputs = form.querySelectorAll('input[type="email"], input[type="password"], input[type="text"]');
    const submitButton = form.querySelector('input[type="submit"]');
    
    // Add professional focus effects
    inputs.forEach(input => {
      input.addEventListener('focus', function() {
        this.classList.add('ring-2', 'ring-blue-500', 'ring-opacity-50');
      });
      
      input.addEventListener('blur', function() {
        this.classList.remove('ring-2', 'ring-blue-500', 'ring-opacity-50');
      });
      
      // Basic validation feedback
      input.addEventListener('input', function() {
        validateField(this);
      });
    });
    
    // Professional submit button interaction
    if (submitButton) {
      form.addEventListener('submit', function(e) {
        // Add loading state
        submitButton.innerHTML = 'Processing...';
        submitButton.disabled = true;
        submitButton.classList.add('opacity-75');
      });
    }
  });
});

// Professional field validation
function validateField(field) {
  const value = field.value.trim();
  let isValid = true;
  
  // Remove existing error styling
  field.classList.remove('border-red-500');
  
  // Basic validation rules
  if (field.type === 'email' && value) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    isValid = emailRegex.test(value);
  } else if (field.type === 'password' && value) {
    isValid = value.length >= 6;
  } else if (field.required && !value) {
    isValid = false;
  }
  
  // Apply error styling if invalid
  if (!isValid && value) {
    field.classList.add('border-red-500');
  }
  
  return isValid;
}