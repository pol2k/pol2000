<script>
  let { ratio = '1fr 1fr', children } = $props();
</script>

<div class="deux" style="grid-template-columns: {ratio}">{@render children()}</div>
