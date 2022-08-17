# GodotDialogComposer

## Result json may contain following data:

### Phrase node
### Response node
### Condition node

### Export data example

```json
{
  "0": {
    "commands": [
      "command_text"
    ],
    "graph_data": {
      "height": 144,
      "initial_node": true,
      "node_name": "61554405",
      "width": 135,
      "x": 422,
      "y": 147
    },
    "next": 1,
    "text": "Hi",
    "type": "dialog"
  },
  "1": {
    "conditions": [
      "condition_name = true"
    ],
    "false": null,
    "graph_data": {
      "height": 175,
      "initial_node": false,
      "node_name": "59636181",
      "width": 232,
      "x": 680,
      "y": 140
    },
    "true": 2,
    "type": "condition"
  },
  "2": {
    "commands": [
      "command_text_second"
    ],
    "graph_data": {
      "height": 384,
      "initial_node": false,
      "node_name": "59648037",
      "width": 257,
      "x": 1020,
      "y": 140
    },
    "responses": [
      {
        "conditions": null,
        "next": null,
        "text": "answer 1"
      },
      {
        "conditions": null,
        "next": null,
        "text": "answer 2"
      }
    ],
    "text": "some respose text",
    "type": "response"
  },
  "connections": [
    {
      "from": "61554405",
      "from_port": 0,
      "to": "59636181",
      "to_port": 0
    },
    {
      "from": "59636181",
      "from_port": 0,
      "to": "59648037",
      "to_port": 0
    }
  ]
}
```