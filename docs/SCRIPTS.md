# Scripts

```bash
find -type f \( -iname *.lua -o -iname *.xml -o -iname *.toc -o -iname *.txt \) | while read f; do tail -n1 $f | read -r _ || echo >> $f; done
```
