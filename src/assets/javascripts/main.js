import Amber from 'amber'

const removeAlert = (time) => {
  const $alert = document.querySelector('.alert')
  if ($alert) {
    setTimeout(() => {
      $alert.remove()
    }, time);
  }
}

// Remove Alert after 2 seconds
removeAlert(2000)