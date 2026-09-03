<script>
  import { REFERENCES } from '$lib/data/references.js';
  let { k } = $props();
  const r = REFERENCES[k];
</script>

{#if r}<span class="cite">{r.court}</span>{:else}<span class="cite manquante">?{k}</span>{/if}
