
$(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case 'showLogo':
				this.console.log()
				$('body').css('opacity', '1.0')
				break
			case 'hide':
				$('body').css('opacity', '0.0')
		}
	})
})