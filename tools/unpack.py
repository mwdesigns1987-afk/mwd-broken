import json,glob,os,base64,shutil
shutil.rmtree('_site',ignore_errors=True);shutil.copytree('site','_site')
for c in sorted(glob.glob('bundles/*.json')):
  for p,b in json.load(open(c)).items():
    os.makedirs(os.path.dirname(os.path.join('_site',p)) or '_site',exist_ok=True)
    open(os.path.join('_site',p),'wb').write(base64.b64decode(b))
open('_site/.nojekyll','w').close()
print(sum(len(f) for _,_,f in os.walk('_site')),'files')
