"""
Test custom Django management commands
"""
# provide possibility to emulate the database behaviour
from unittest.mock import patch

# one of errors that we might get when we are trying to connect to database
# before it's finishes the configuration
from psycopg2 import OperationalError as Psycopg2Error

# allows to simulate behaviour of entering command in commandline
from django.core.management import call_command
# another error that can occure if trying to connect to the database before it
# finishes the configuration
from django.db.utils import OperationalError
# base class that is used for testing
from django.test import SimpleTestCase


@patch('core.management.commands.wait_for_db.Command.check')
class CommandTests(SimpleTestCase):
    """Test commands"""
    def test_wait_for_db_ready(self, patched_check):
        """Test waiting for database command if database is ready"""
        patched_check.return_value = True

        call_command('wait_for_db')

        patched_check.assert_called_once_with(databases=['default'])

    @patch('time.sleep')
    def test_wait_for_db_delay(self, patched_sleep, patched_check):
        """Test waiting for database when getting OperationalError"""
        # use side effect of raising errors
        patched_check.side_effect = [Psycopg2Error] * 2 + \
            [OperationalError] * 3 + [True]

        call_command('wait_for_db')

        self.assertEqual(patched_check.call_count, 6)
        patched_check.assert_called_with(databases=['default'])
