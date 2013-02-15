Feature: nginx-fastcgi should be able to validate it's input parameters

Scenario: try to install without server_name 
    Given I run 'rm -rf /tmp/foo.site.conf'
    Then a file named '/tmp/foo.site.conf' should not exist
    And I have chef recipe:
    """
        nginx_fastcgi '/tmp/foo.site.conf' do
            servers [
                {
                    :ip => '127.0.0.1'
                }
            ]
            socket '/tmp/application.socket'
        end
    """
    When I run chef recipe on my node
    Then 'stdout' should have 'RuntimeError: you should setup server_name for your virtual host'
    Then a file named '/tmp/foo.site.conf' should not exist

Scenario: try to install without ssl_inlcude_path
    Given I run 'rm -rf /tmp/foo.site.conf'
    Then a file named '/tmp/foo.site.conf' should not exist
    And I have chef recipe:
    """
        nginx_fastcgi '/tmp/foo.site.conf' do
            site_name 'foo.site.x'
            servers [
                {
                    :server_name => 'foo.x',
                    :ssl => true
                }
            ]
            socket '/tmp/application.socket'
        end
    """
    When I run chef recipe on my node
    Then 'stdout' should have 'RuntimeError: you should setup ssl_include_path for your virtual host'
    Then a file named '/tmp/foo.site.conf' should not exist

Scenario: try to install without server_name 
    Given I run 'rm -rf /tmp/foo.site.conf'
    Then a file named '/tmp/foo.site.conf' should not exist
    And I have chef recipe:
    """
        nginx_fastcgi '/tmp/foo.site.conf' do
            servers [
                {
                    :server_name => 'foo.x',
                    :ip => '127.0.0.1'
                }
            ]
        end
    """
    When I run chef recipe on my node
    Then 'stdout' should have 'RuntimeError: you should setup socket'
    Then a file named '/tmp/foo.site.conf' should not exist

