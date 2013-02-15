Feature: nginx-fastcgi should be able to install ssl enabled nginx site config

Backgound: delete old configs
    Given I run 'rm -rf /tmp/foo.site.conf'
    Then a file named '/tmp/foo.site.conf' should not exist

Scenario: install nginx ssl site config
    And I have chef recipe:
    """
        nginx_fastcgi '/tmp/foo.site.conf' do
            servers [
                {
                    :ip => '127.0.0.1',
                    :server_name => 'bar.site.x',
                    :redirect => 'https'                
                },
                {
                    :ip => '127.0.0.1',
                    :server_name => 'bar.site.x',
                    :ssl => true,
                    :ssl_include_path => 'nginx_ssl_settings.conf'
                    
                }
            ]
            socket '/tmp/application.socket'
        end
    """
    When I run chef recipe on my node
    Then a file named '/tmp/foo.site.conf' should exist
    And a file named '/tmp/foo.site.conf' should contain 'rewrite  \^ https://\$server_name\$request_uri\? permanent'


