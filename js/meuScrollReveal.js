
function initScrollReveal() {

    ScrollReveal().reveal('.headline', {
        reset: true,
        duration: 1000,
        origin: 'right'
    });


    if (window.innerWidth < 768) {
        ScrollReveal().reveal('.headline', {
            reset: true,
            duration: 1000,
            distance: '0',
            origin: 'bottom'
        });
    }

    ScrollReveal().reveal('.rolagem1');
}

document.addEventListener('DOMContentLoaded', function() {
    initScrollReveal();
});
