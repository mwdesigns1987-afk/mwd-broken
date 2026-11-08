import json,glob,os,base64,shutil
shutil.rmtree('_site',ignore_errors=True);shutil.copytree('site','_site')
for c in sorted(glob.glob('bundles/*.json')):
  for k,b in json.load(open(c)).items():
    p,_,n=k.partition('|');d=os.path.join('_site',p)
    os.makedirs(os.path.dirname(d) or '_site',exist_ok=True)
    open(d,'ab' if n not in ('','0') else 'wb').write(base64.b64decode(b))
open('_site/.nojekyll','w').close()
print(sum(len(f) for _,_,f in os.walk('_site')),'files')
