"""
Define testing posiblity for this application
"""
from django.test import SimpleTestCase


def summarization(x, y):
    """function that calculates sum of 2 numbers"""
    return x + y


class WorkingTest(SimpleTestCase):
    """Test is this a right way of working application"""

    def test_summarization(self):
        res = summarization(5, 6)
        return self.assertEqual(res, 11)
