import fs from 'node:fs';
const p='modelo_eer_respaldo12.archify.json';
const d=JSON.parse(fs.readFileSync(p,'utf8'));
const groups={
  'tb_buyer_orders':'Operación', 'tb_carts':'Operación', 'tbd_carts_items':'Operación', 'tbd_order_items':'Operación', 'tbd_users_wishlist_products':'Operación', 'tbd_user_payment_methods_history':'Operación',
  'tb_categories':'Catálogo y pagos', 'tb_products':'Catálogo y pagos', 'tbd_products_categories':'Catálogo y pagos', 'tbd_products_users_providers':'Catálogo y pagos', 'tbc_payment_methods_types':'Catálogo y pagos', 'tbd_user_payment_methods':'Catálogo y pagos',
  'tb_people':'Cuentas e infraestructura', 'tb_user_addresses':'Cuentas e infraestructura', 'tb_users':'Cuentas e infraestructura', 'tbd_address_components':'Cuentas e infraestructura', 'tb_logs':'Cuentas e infraestructura'
};
const col={ 'Operación':0,'Catálogo y pagos':1,'Cuentas e infraestructura':2 }, rows={};
for(const e of d.entities){e.tag=groups[e.id];e.col=col[e.tag];e.row=rows[e.tag]||0;rows[e.tag]=(rows[e.tag]||0)+1;}
const widths={tb_buyer_orders:679,tb_logs:407,tb_people:414,tbd_products_users_providers:414,tbd_user_payment_methods:337,tbd_user_payment_methods_history:337};
for(const e of d.entities)e.width=widths[e.id]||300;
const self=d.relationships.filter(r=>r.from===r.to);
d.relationships=d.relationships.filter(r=>r.from!==r.to);
for(const r of d.relationships)if(r.label.includes('fk_addresses_users'))r.labelDy=24;
d.cards=[{dot:'amber',title:'Referencias a la misma tabla',items:self.map(r=>`${r.from}.${r.label.split(' • ')[0]}: ${r.label.split(' • ')[1]||'FK'}. La referencia apunta a otra fila de la misma tabla.`)}];
fs.writeFileSync(p,JSON.stringify(d,null,2));
