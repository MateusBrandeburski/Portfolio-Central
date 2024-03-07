function initScrollReveal() {

    ScrollReveal().reveal('.headline', {
        reset: false, 
        duration: 1000,
        origin: 'right'
    });


    if (window.innerWidth < 768) {
        ScrollReveal().reveal('.headline', {
            reset: false, 
            duration: 1000,
            distance: '0',
            origin: 'bottom'
        });
    }

    ScrollReveal().reveal('.rolagem1', {
        reset: false 
    });
}

document.addEventListener('DOMContentLoaded', function() {
    initScrollReveal();
});
