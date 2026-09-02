<script>
  let { valeur, legende = '', ton = 'accent' } = $props();
</script>

<div class="grand {ton}">
  <span class="v">{valeur}</span>
  {#if legende}<span class="l">{legende}</span>{/if}
</div>
