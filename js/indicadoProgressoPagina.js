function updateProgressBar() {
    const scrollableHeight = document.documentElement.scrollHeight - window.innerHeight;
    const scrollTop = window.scrollY;
    const progress = (scrollTop / scrollableHeight) * 100;
    const progressBar = document.getElementById('scroll-progress');
    progressBar.style.width = progress + '%';
}
window.addEventListener('scroll', updateProgressBar);


