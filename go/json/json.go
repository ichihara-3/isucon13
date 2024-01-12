package json

import (
	"github.com/bytedance/sonic"

	"github.com/labstack/echo/v4"
)

// DefaultJSONSerializer implements JSON encoding using encoding/json.
type GoJSONSerializer struct{}

// Serialize converts an interface into a json and writes it to the response.
// You can optionally use the indent parameter to produce pretty JSONs.
func (s GoJSONSerializer) Serialize(c echo.Context, i interface{}, indent string) error {
	enc := sonic.ConfigDefault.NewEncoder(c.Response())
	if indent != "" {
		enc.SetIndent("", indent)
	}
	return enc.Encode(i)
}

// Deserialize reads a JSON from a request body and converts it into an interface.
func (s GoJSONSerializer) Deserialize(c echo.Context, i interface{}) error {
	err := sonic.ConfigDefault.NewDecoder(c.Request().Body).Decode(i)
	return err
}