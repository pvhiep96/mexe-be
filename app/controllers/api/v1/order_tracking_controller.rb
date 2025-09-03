class Api::V1::OrderTrackingController < ApplicationController
  before_action :authenticate_user!, except: [:track_by_number]
  
  def my_orders
    orders = current_user.orders.includes(:products, :order_items)
                          .order(created_at: :desc)
    
    render json: {
      success: true,
      data: orders.map { |order| serialize_order(order) }
    }
  end

  def show
    order = current_user.orders.find_by(id: params[:id])
    
    if order
      render json: {
        success: true,
        data: serialize_order_detail(order)
      }
    else
      render json: {
        success: false,
        message: 'Không tìm thấy đơn hàng'
      }, status: :not_found
    end
  end

  # Track order by order number (for guest users)
  def track_by_number
    order = Order.find_by(order_number: params[:order_number])
    
    if order && (order.guest_email == params[:email] || order.user&.email == params[:email])
      render json: {
        success: true,
        data: serialize_order_detail(order)
      }
    else
      render json: {
        success: false,
        message: 'Không tìm thấy đơn hàng hoặc thông tin không chính xác'
      }, status: :not_found
    end
  end

  private

  def serialize_order(order)
    {
      id: order.id,
      order_number: order.order_number,
      status: order.status,
      status_processed: order.status_processed,
      status_processed_text: order.processing_status_text,
      total_amount: order.total_amount,
      created_at: order.created_at,
      shipping_provider: order.shipping_provider_name,
      tracking_number: order.tracking_number,
      tracking_url: order.full_tracking_url,
      shipped_at: order.shipped_at,
      delivered_at: order.delivered_at,
      products_count: order.products.count
    }
  end

  def serialize_order_detail(order)
    {
      id: order.id,
      order_number: order.order_number,
      status: order.status,
      status_processed: order.status_processed,
      status_processed_text: order.processing_status_text,
      subtotal: order.subtotal,
      discount_amount: order.discount_amount,
      shipping_fee: order.shipping_fee,
      tax_amount: order.tax_amount,
      total_amount: order.total_amount,
      payment_method: order.payment_method,
      payment_status: order.payment_status,
      delivery_address: order.delivery_address,
      notes: order.notes,
      created_at: order.created_at,
      updated_at: order.updated_at,
      
      # Shipping information
      shipping_info: {
        provider: order.shipping_provider_name,
        tracking_number: order.tracking_number,
        tracking_url: order.full_tracking_url,
        shipped_at: order.shipped_at,
        delivered_at: order.delivered_at
      },
      
      # Products
      items: order.order_items.includes(:product).map do |item|
        {
          product_id: item.product.id,
          product_name: item.product.name,
          product_sku: item.product.sku,
          quantity: item.quantity,
          unit_price: item.unit_price,
          subtotal: item.quantity * item.unit_price,
          product: {
            images: item.product.product_images.limit(1).map do |img|
              {
                url: img.image.url,
                alt_text: img.alt_text
              }
            end
          }
        }
      end,
      
      # Timeline
      timeline: build_order_timeline(order)
    }
  end

  def build_order_timeline(order)
    timeline = []
    
    # Order created
    timeline << {
      status: 'created',
      title: 'Đơn hàng đã được tạo',
      description: 'Đơn hàng của bạn đã được tiếp nhận và đang chờ xử lý',
      timestamp: order.created_at,
      completed: true
    }
    
    # Processing
    if order.status != 'pending'
      timeline << {
        status: 'processing',
        title: 'Đang xử lý',
        description: 'Đơn hàng đang được xử lý',
        timestamp: order.updated_at,
        completed: true
      }
    end
    
    # Shipped to carrier
    if order.processing_shipped_to_carrier? || order.processing_processing_delivered?
      timeline << {
        status: 'shipped_to_carrier',
        title: 'Đã giao đơn vị vận chuyển',
        description: "Đơn hàng đã được giao cho #{order.shipping_provider_name}",
        timestamp: order.shipped_at,
        completed: true,
        tracking_info: {
          provider: order.shipping_provider_name,
          tracking_number: order.tracking_number,
          tracking_url: order.full_tracking_url
        }
      }
    end
    
    # Delivered
    if order.processing_processing_delivered?
      timeline << {
        status: 'delivered',
        title: 'Đã giao hàng',
        description: 'Đơn hàng đã được giao thành công',
        timestamp: order.delivered_at,
        completed: true
      }
    end
    
    timeline
  end
end