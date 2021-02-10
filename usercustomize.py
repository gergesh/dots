from pathlib import PurePath


def normalize(self):
    normed = self._flavour.pathmod.normpath(self)
    return self._from_parts((normed,))


PurePath.normalize = normalize
