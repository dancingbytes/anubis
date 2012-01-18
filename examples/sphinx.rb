##
## Anubis for noobies
##

indexer do

  mem_limit     "32M"
  max_iops      40
  max_iosize    1048576

end

searchd do
  
#  listen         "127.0.0.1:9315:mysql41"
  log             File.join(Rails.root, "log", "sphinx.log")
  query_log       File.join(Rails.root, "log", "sphinx.query.log")
  pid_file        File.join(Rails.root, "tmp", "pids", "sphinx.pid")
  query_log_format "sphinxql"
  max_matches     30000
  max_children    30
  workers         "threads"
#  binlog_path     "/home/tyralion/work/v_avto_sphinx/db/sphinx/data"
#  binlog_flush    0
#  binlog_max_log_size   "16M"
#  collation_server      "utf8_ci"
  compat_sphinxql_magics  0
  
end

index "items" do

  #type              "rt"
  path              File.join(Rails.root, "db", "sphinx", "items")
  charset_type      "utf-8"
  morphology        "stem_en, stem_ru, soundex"
#  blend_chars       "+, &, U+23"
#  blend_mode        "trim_tail, skip_pure"
  html_remove_elements "style, script"
  preopen           1
  ondisk_dict       0
  inplace_enable    1

  charset_table     "0..9, A..Z->a..z, -, _, ., &, a..z, U+410..U+42F->U+430..U+44F, U+430..U+44F,U+C5->U+E5, U+E5, U+C4->U+E4, U+E4, U+D6->U+F6, U+F6, U+16B, U+0c1->a, U+0c4->a, U+0c9->e, U+0cd->i, U+0d3->o, U+0d4->o, U+0da->u, U+0dd->y, U+0e1->a, U+0e4->a, U+0e9->e, U+0ed->i, U+0f3->o, U+0f4->o, U+0fa->u, U+0fd->y, U+104->U+105, U+105, U+106->U+107, U+10c->c, U+10d->c, U+10e->d, U+10f->d, U+116->U+117, U+117, U+118->U+119, U+11a->e, U+11b->e, U+12E->U+12F, U+12F, U+139->l, U+13a->l, U+13d->l, U+13e->l, U+141->U+142, U+142, U+143->U+144, U+144,U+147->n, U+148->n, U+154->r, U+155->r, U+158->r, U+159->r, U+15A->U+15B, U+15B, U+160->s, U+160->U+161, U+161->s, U+164->t, U+165->t, U+16A->U+16B, U+16B, U+16e->u, U+16f->u, U+172->U+173, U+173, U+179->U+17A, U+17A, U+17B->U+17C, U+17C, U+17d->z, U+17e->z"

#  rt_mem_limit      "128M"
  
  rt_field          "name"
  rt_field          "description"
  
#  rt_attr_uint      "catalog_id"
#  rt_attr_uint      "brand_id"
#  rt_attr_uint      "price"
#  rt_attr_uint      "catalog_lft"
#  rt_attr_uint      "catalog_rgt"
#  rt_attr_uint      "catalog_public"
#  rt_attr_uint      "available"
#  rt_attr_uint      "public"

#  rt_attr_timestamp "created_at"

  rt_attr_string    "name"
  rt_attr_string    "description"

#  rt_attr_string    "catalog_url_path"
#  rt_attr_string    "brand_name"
#  rt_attr_string    "catalog_name"
#  rt_attr_string    "marking_of_goods"

end