import fs from 'node:fs';

const sql = fs.readFileSync('backups/respaldo12.sql', 'utf8');
const html = fs.readFileSync('modelo_eer_diccionario_respaldo12.html', 'utf8');
const start = html.indexOf('const ROUTINES=');
if (start < 0) throw new Error('No se encontró el inventario de rutinas embebido en el HTML');
let depth = 0, quoted = false, escaped = false, end = -1;
for (let i = html.indexOf('{', start); i < html.length; i++) {
  const c = html[i];
  if (quoted) { if (escaped) escaped = false; else if (c === '\\') escaped = true; else if (c === '"') quoted = false; continue; }
  if (c === '"') quoted = true;
  else if (c === '{') depth++;
  else if (c === '}' && --depth === 0) { end = i + 1; break; }
}
if (end < 0) throw new Error('JSON de rutinas inválido en el HTML');
const embedded = JSON.parse(html.slice(html.indexOf('{', start), end));
const tables = new Set([...sql.matchAll(/CREATE TABLE `([^`]+)`/g)].map(x => x[1]));
const executableSql = sql.replace(/\/\*!\d*\s*([\s\S]*?)\*\//g, '$1');
const routines = [...executableSql.matchAll(/CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?(PROCEDURE|FUNCTION|TRIGGER|EVENT)\s+`([^`]+)`([\s\S]*?)\s+END\s*;/gi)].map(m => ({
  type: m[1].toUpperCase(), name: m[2], definition: m[0].trim()
}));
const items = routines.map(r => {
  const embeddedItem = embedded.items.find(x => x.name === r.name);
  if (!embeddedItem) throw new Error(`Rutina no incluida en el HTML: ${r.name}`);
  const table = r.type === 'TRIGGER' ? (r.definition.match(/\bON\s+`([^`]+)`/i)?.[1] ?? null) : null;
  const references = [...r.definition.matchAll(/\b(?:FROM|JOIN|INTO|UPDATE|DELETE\s+FROM)\s+`([^`]+)`/gi)].map(x => x[1]);
  const impacts = [...new Set([table, ...references].filter(Boolean))];
  const params = r.type === 'TRIGGER' ? ['OLD', 'NEW'] : [...(r.definition.match(/\(([^)]*)\)/)?.[1] ?? '').matchAll(/(?:IN|OUT|INOUT)\s+`?([\w$]+)`?\s+([^,]+)/gi)].map(x => ({name:x[1], type:x[2].trim()}));
  const description = r.type === 'TRIGGER'
    ? `${embeddedItem.timing} ${embeddedItem.event} sobre ${table}; implementa reglas de negocio y/o auditoría al ocurrir el evento.`
    : `${r.type} almacenado en el respaldo.`;
  return {name:r.name, type:r.type, parameters:params, timing:embeddedItem.timing ?? null, event:embeddedItem.event ?? null,
    table, impacted_tables:impacts, missing_table_references:impacts.filter(t => !tables.has(t)), description,
    source_definition:r.definition, source_body:embeddedItem.body ?? null};
});
const counts = Object.fromEntries(['PROCEDURE','FUNCTION','TRIGGER','EVENT'].map(type => [type, items.filter(x => x.type === type).length]));
if (items.length !== embedded.items.length) throw new Error(`Conteo SQL/HTML no coincide: ${items.length}/${embedded.items.length}`);
fs.writeFileSync('procedimientos_respaldo12.json', JSON.stringify({source:'backups/respaldo12.sql', database:'db_test', dialect:'MySQL 8.0.36', counts, total_routines:items.length, items}, null, 2)+'\n', 'utf8');
console.log(JSON.stringify({counts, items:items.length, missingReferences:items.filter(x=>x.missing_table_references.length).map(x=>({name:x.name,tables:x.missing_table_references}))}, null, 2));
