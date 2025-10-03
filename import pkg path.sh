
import os
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from Users_anton_bin_Bash import get_pkg_path

class TestBashPkg:
    def test_pkg_directory_exists(self):
        pkg_path = get_pkg_path()
        assert os.path.isdir(pkg_path), f"Directory {pkg_path} does not exist"

    def test_user_has_directory_access(self):
        pkg_path = get_pkg_path()
        assert os.access(pkg_path, os.R_OK | os.W_OK | os.X_OK), f"User 'anton' does not have necessary permissions to access {pkg_path}"

    def test_pkg_file_exists(self):
        pkg_path = get_pkg_path()
        expected_file_path = os.path.join(pkg_path, 'pkg')
        assert os.path.isfile(expected_file_path), f"File 'pkg' does not exist at {expected_file_path}"

    def test_pkg_file_extension(self):
        pkg_path = get_pkg_path()
        file_name = os.path.basename(pkg_path)
        assert file_name == 'pkg', f"File name should be 'pkg', but got '{file_name}'"

    def test_path_format_for_windows(self):
        pkg_path = get_pkg_path()
        assert pkg_path.startswith('C:'), "Path should start with 'C:'"
        assert '' in pkg_path, "Path should use backslashes as separators"
        assert pkg_path.endswith('\\pkg'), "Path should end with '\\pkg'"
        assert pkg_path.count('') >= 4, "Path should have at least 4 backslashes"
        assert 'Users' in pkg_path and 'anton' in pkg_path and 'bin' in pkg_path and 'Bash' in pkg_path, "Path should include 'Users', 'anton', 'bin', and 'Bash' directories"

    def test_bash_directory_contains_required_files(self):
        pkg_path = get_pkg_path()
        bash_dir = os.path.dirname(pkg_path)
        required_files = ['pkg', 'install', 'remove', 'update']
        
        for file in required_files:
            file_path = os.path.join(bash_dir, file)
            assert os.path.isfile(file_path), f"Required file '{file}' does not exist in the Bash directory"

    def test_bin_directory_location(self):
        pkg_path = get_pkg_path()
        user_profile = os.path.expanduser('~')
        expected_bin_path = os.path.join(user_profile, 'bin')
        assert os.path.dirname(os.path.dirname(pkg_path)) == expected_bin_path, f"The 'bin' directory is not in the correct location. Expected: {expected_bin_path}, Actual: {os.path.dirname(os.path.dirname(pkg_path))}"

    def test_path_with_special_characters_in_username(self):
        pkg_path = get_pkg_path()
        assert 'C:\\Users\\anton\\bin\\Bash\\pkg' in pkg_path, "Path should work with spaces or special characters in the username"
        assert os.path.exists(pkg_path), f"Path {pkg_path} should exist even with special characters in the username"

    def test_path_in_system_environment(self):
        pkg_path = get_pkg_path()
        system_path = os.environ.get('PATH', '').split(os.pathsep)
        pkg_dir = os.path.dirname(pkg_path)
        assert pkg_dir in system_path, f"Directory {pkg_dir} is not in the system's PATH environment variable"

    def test_pkg_file_is_executable(self):
        pkg_path = get_pkg_path()
        assert os.access(pkg_path, os.X_OK), f"The 'pkg' file at {pkg_path} is not executable"
