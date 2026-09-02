<script>
  let { ton = 'ciel', titre = '', children } = $props();
</script>

<div class="carte-d {ton}">
  {#if titre}<h4>{titre}</h4>{/if}
  {@render children()}
</div>
