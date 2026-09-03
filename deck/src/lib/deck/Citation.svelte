<script>
  let { source = '', children } = $props();
</script>

<blockquote class="cit">
  {@render children()}
  {#if source}<cite>{source}</cite>{/if}
</blockquote>
