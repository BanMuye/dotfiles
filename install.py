import sys
import config_sync
from path_sync import PathSynchronizer

if __name__ == "__main__":

    # try sync config
    if not config_sync.main():
        sys.exit(1)
    print("=="*80)
    print("finish config sync")
    print("=="*80)

    # try sync path
    path_synchronizer = PathSynchronizer()
    path_synchronizer.sync_paths()
    print("=="*80)
    print("finish path sync")
    print("=="*80)
