require 'spec_helper'


describe MetaModel do
  it 'has a version number' do
    expect(MetaModel::VERSION).not_to be nil
  end

  it 'parse and creates metamodels from a jsonapi body' do
    body = {
      data: {
        id: '1',
        type: 'maps',
        attributes: {
          address: 'One infinite loop, Cupertino, CA'
        },
        relationships: {
          state: {
            data: {
              id: 'CA',
              type: 'states'
            }
          }
        }
      },
      included: [
        {
          id: 'CA',
          type: 'states',
          attributes: {
            name: 'California'
          }
        }
      ]
    }
    model = MetaModel::MetaModel.new(body)
    expect(model.state).not_to be_nil
    serialized = ActiveModelSerializers::SerializableResource.new(model, {adapter: :json_api, key_transform: :unaltered, include: '*'})
    expect(serialized.to_json).to eq body.to_json
  end
end
