import json
from pathlib import Path, PurePath


def normalize(self):
    normed = self._flavour.pathmod.normpath(self)
    return self._from_parts((normed,))


PurePath.normalize = normalize


def read_json(self, encoding=None, errors=None):
    with self.open(mode='r', encoding=encoding, errors=errors) as f:
        return json.load(f)

def write_json(self, obj, encoding=None, errors=None):
    with self.open(mode='w', encoding=encoding, errors=errors) as f:
        return json.dump(obj, f)


Path.read_json = read_json
Path.write_json = write_json
